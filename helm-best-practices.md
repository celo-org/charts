# Helm Chart Best Practices

## Table of Contents

- [Helm Chart Best Practices](#helm-chart-best-practices)
  - [Table of Contents](#table-of-contents)
  - [Goal](#goal)
  - [General](#general)
  - [Values](#values)
  - [Templates](#templates)
  - [References](#references)

---

## Goal

Collect considered best practices for creating charts. This guide focus primarily on best practices for charts that may be publicly deployed. Many charts are for internal-use only, and authors of such charts may find that their internal interests override suggestions here.

## General

1. Chart names must be lower case letters and numbers. Words may be separated with dashes (-). Neither uppercase letters nor underscores can be used in chart names. Dots should not be used in chart names.
2. Helm uses [SemVer 2](https://semver.org/) to represent version numbers.
3. YAML files should be indented using two spaces (and never tabs).
4. Using the words Helm and helm:
   1. Helm refers to the project as a whole.
   2. `helm` refers to the client-side command.
   3. The term `chart` does not need to be capitalized, as it is not a proper noun.
   4. However, Chart.yaml does need to be capitalized because the file name is case sensitive.
   5. When in doubt, use Helm (with an uppercase 'H').

## Values

Focus on designing a chart's values.yaml file.

1. Variable names should begin with a lowercase letter, and words should be separated with camelcase.
   1. Helm's built-in variables begin with an uppercase letter to easily distinguish them from user-defined values: `.Release.Name`, `.Capabilities.KubeVersion`.
2. Flat values should be favored over nested. The reason for this is that it is simpler for template developers and users.

    Flat:

    ```yaml
    serverName: nginx
    serverPort: 80
    ```

    Nested:

    ```yaml
    server:
      name: nginx
      port: 80
    ```

   1. However, when there are a large number of related variables, and at least one of them is non-optional, nested values may be used to improve readability.

3. To avoid type conversion errors is to be explicit about strings, and implicit about everything else. Or, in short, quote all strings.
   1. Large integers like `foo: 12345678` will get converted to scientific notation in some cases. To avoid the integer casting issues, it is advantageous to store your integers as strings as well, and use `{{ int $value }}` in the template to convert from a string back to an integer.
4. It's often better to structure your values file using maps in order to make it easy to override from `--set`.
5. Every defined property in values.yaml should be documented. The documentation string should begin with the name of the property that it describes, and then give at least a one-sentence description.
   1. **TODO:** Evaluate [`helm-docs`](https://github.com/norwoodj/helm-docs) and its automation.

## Templates

1. The `templates/` directory should be structured as follows:
   1. Template files should have the extension `.yaml` if they produce YAML output. The extension `.tpl` may be used for template files that produce no formatted content.
   2. Template file names should use dashed notation (`my-example-configmap.yaml`), not camelcase.
   3. Each resource definition should be in its own template file.
   4. Template file names should reflect the resource kind in the name. e.g. `foo-po.yaml`, `bar-svc.yaml` using abbreviations of Kubernetes Resource Types (if they exist):

      | Abbreviation | Full name               |
      | ------------ | ----------------------- |
      | svc          | service                 |
      | deploy       | deployment              |
      | cm           | configmap               |
      | secret       | secret                  |
      | ds           | daemonset               |
      | rc           | replicationcontroller   |
      | petset       | petset                  |
      | po           | pod                     |
      | hpa          | horizontalpodautoscaler |
      | ing          | ingress                 |
      | job          | job                     |
      | limit        | limitrange              |
      | ns           | namespace               |
      | pv           | persistentvolume        |
      | pvc          | persistentvolumeclaim   |
      | sa           | serviceaccount          |

2. All defined template (templates created inside a `{{ define }}` directive) names should be namespaced because they are  globally accessible.

    Correct:

    ```go
    {{- define "nginx.fullname" }}
    {{/* ... */}}
    {{ end -}}
    ```

    Incorrect:

    ```go
    {{- define "fullname" -}}
    {{/* ... */}}
    {{ end -}}
    ```

3. Templates should be indented using two spaces (never tabs).

4. Template directives should have whitespace after the opening braces and before the closing braces:

    Correct:

    ```go
    {{ .foo }}
    {{ print "foo" }}
    {{- print "bar" -}}
    ```

    Incorrect:

    ```go
    {{.foo}}
    {{print "foo"}}
    {{-print "bar"-}}
    ```

5. Chomp whitespace where possible:

    ```go
    foo:
      {{- range .Values.items }}
      {{ . }}
      {{ end -}}
    ```

6. Blocks (such as control structures) may be indented to indicate flow of the template code.

    ```go
    {{ if $foo -}}
      {{- with .Bar }}Hello{{ end -}}
    {{- end -}}
    ```

    > :warning: Since YAML is a whitespace-oriented language, it is often not possible for code indentation to follow that convention.

7. Keep the amount of whitespace in generated templates to a minimum. In particular, numerous blank lines should not appear adjacent to each other. But occasional empty lines (particularly between logical sections) is fine.

    Best:

    ```go
    apiVersion: batch/v1
    kind: Job
    metadata:
      name: example
      labels:
        first: first
        second: second
    ```

    Okay:

    ```go
    apiVersion: batch/v1
    kind: Job

    metadata:
      name: example

      labels:
        first: first
        second: second
    ```

    Avoid:

    ```go
    apiVersion: batch/v1
    kind: Job

    metadata:
      name: example





      labels:
        first: first

        second: second
    ```

8. Comments

    YAML comments:

    ```yaml
    # This is a comment
    type: sprocket
    ```

    Template Comments:

    ```go
    {{- /*
    This is a comment.
    */}}
    type: frobnitz
    ```

9. YAML is a superset of JSON. In some cases, using a JSON syntax can be more readable than other YAML representations. Using JSON for increased legibility is good. However, JSON syntax should not be used for representing more complex constructs.

    When dealing with pure JSON embedded inside of YAML (such as init container configuration), it is of course appropriate to use the JSON format.

## References

- [helm.sh Chart Best Practices Guide](https://helm.sh/docs/chart_best_practices/)
- [Honestbee - Helm Chart Conventions](https://gist.github.com/so0k/f927a4b60003cedd101a0911757c605a)
