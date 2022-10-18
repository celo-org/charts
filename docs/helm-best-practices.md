# Helm Chart Best Practices

## Table of Contents

- [Helm Chart Best Practices](#helm-chart-best-practices)
  - [Table of Contents](#table-of-contents)
  - [Goal](#goal)
  - [General](#general)
  - [Chart.yaml file](#chartyaml-file)
  - [Values](#values)
  - [Templates](#templates)
  - [Dependencies](#dependencies)
  - [Labels And Annotations](#labels-and-annotations)
  - [Pods and PodTemplates](#pods-and-podtemplates)
  - [Custom Resource Definitions](#custom-resource-definitions)
  - [Role-Based Access Control](#role-based-access-control)
  - [Documentation](#documentation)
  - [Technical](#technical)
  - [References](#references)

---

## Goal

Collect considered best practices for creating charts. This guide focuses primarily on best practices for charts that may be publicly deployed. Many charts are for internal-use only, and authors of such charts may find that their internal interests override suggestions here.

An example of a formatted Helm chart `foo` created with `helm create foo` can be found in folder [`docs/examples/foo`](examples/foo/).

## General

1. Chart names must be lower case letters and numbers. Words may be separated with dashes (`-`). Neither uppercase letters nor underscores can be used in chart names. Dots should not be used in chart names.
2. Helm uses [SemVer 2](https://semver.org/) to represent version numbers.
3. YAML files should be indented using two spaces (and never tabs).
4. Using the words Helm and helm:
   1. Helm refers to the project as a whole.
   2. `helm` refers to the client-side command.
   3. The term `chart` does not need to be capitalized, as it is not a proper noun.
   4. However, Chart.yaml does need to be capitalized because the file name is case sensitive.
   5. When in doubt, use Helm (with an uppercase 'H').
5. The chart directory follows these conventions:
    1. The directory name is the name of the chart (without versioning information).
    2. Helm will expect a structure that matches this:

        ```plaintext
        chart-name/
          Chart.yaml          # A YAML file containing information about the chart
          LICENSE             # OPTIONAL: A plain text file containing the license for the chart
          README.md           # OPTIONAL: A human-readable README file
          values.yaml         # The default configuration values for this chart
          values.schema.json  # OPTIONAL: A JSON Schema for imposing a structure on the values.yaml file
          charts/             # A directory containing any charts upon which this chart depends.
          crds/               # Custom Resource Definitions
          templates/          # A directory of templates that, when combined with values,
                              # will generate valid Kubernetes manifest files.
          templates/NOTES.txt # OPTIONAL: A plain text file containing short usage notes
        ```

    3. Directories `charts/`, `crds/`, and `templates/` are **reserved**.

## Chart.yaml file

1. The `Chart.yaml` file is required for a chart. It contains the following fields:

    ```plaintext
    apiVersion: The chart API version (required)
    name: The name of the chart (required)
    version: A SemVer 2 version (required)
    kubeVersion: A SemVer range of compatible Kubernetes versions (optional)
    description: A single-sentence description of this project (optional)
    type: The type of the chart (optional)
    keywords:
      - A list of keywords about this project (optional)
    home: The URL of this projects home page (optional)
    sources:
      - A list of URLs to source code for this project (optional)
    dependencies: # A list of the chart requirements (optional)
      - name: The name of the chart (nginx)
        version: The version of the chart ("1.2.3")
        repository: (optional) The repository URL ("https://example.com/charts") or alias ("@repo-name")
        condition: (optional) A yaml path that resolves to a boolean, used for enabling/disabling charts (e.g. subchart1.enabled )
        tags: # (optional)
          - Tags can be used to group charts for enabling/disabling together
        import-values: # (optional)
          - ImportValues holds the mapping of source values to parent key to be imported. Each item can be a string or pair of child/parent sublist items.
        alias: (optional) Alias to be used for the chart. Useful when you have to add the same chart multiple times
    maintainers: # (optional)
      - name: The maintainers name (required for each maintainer)
        email: The maintainers email (optional for each maintainer)
        url: A URL for the maintainer (optional for each maintainer)
    icon: A URL to an SVG or PNG image to be used as an icon (optional).
    appVersion: The version of the app that this contains (optional). Needn't be SemVer. Quotes recommended.
    deprecated: Whether this chart is deprecated (optional, boolean)
    annotations:
      example: A list of annotations keyed by name (optional).
    ```

    1. The apiVersion field should be `v2` for Helm charts that require at least Helm 3. Charts supporting previous Helm versions have an apiVersion set to `v1` and are still installable by Helm 3.
    2. The `appVersion` field is informational and optional, and has no impact on chart version calculations. But it is **recommended**.
    3. The `type` field defines the type of chart. There are two types: application and library.
       1. Application is the default type and it is the standard chart which can be operated on fully.
       2. Library charts provides utilities or functions for the chart builder. A library chart differs from an application chart because it is not installable and usually doesn't contain any resource objects.

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

Helm chart templates are basically Go templates. A developer's guide for chart templates can be found [here](https://helm.sh/docs/chart_template_guide/).

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
   5. If applicable, prefix the files with the name of the Chart component (i.e an elasticsearch cluster has master, client and data components).
        For example:

        ```plaintext
        master-deploy.yaml  # deployment of a master component
        web-deploy.yaml     # deployment of a web component
        web-svc.yaml        # service definition of a web component
        registry-rc.yaml    # replication controller of a registry component
        ```

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

    ```yaml
    apiVersion: batch/v1
    kind: Job
    metadata:
      name: example
      labels:
        first: first
        second: second
    ```

    Okay:

    ```yaml
    apiVersion: batch/v1
    kind: Job

    metadata:
      name: example

      labels:
        first: first
        second: second
    ```

    Avoid:

    ```yaml
    apiVersion: batch/v1
    kind: Job

    metadata:
      name: example





      labels:
        first: first

        second: second
    ```

8. Comments.
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

## Dependencies

1. Use version ranges instead of pinning to an exact version. The suggested default is to use a patch-level version match:

    ```yaml
    version: ~1.2.3
    ```

    The following provides a pre-release as well as patch-level matching:

    ```yaml
    version: ~1.2.3-0
    ```

2. Where possible, use `oci://` or `https://` repository URLs, followed by `http://` URLs.
3. Conditions or tags should be added to any dependencies that are optional.
    The preferred form of a condition is:

    ```yaml
    condition: somechart.enabled
    ```

    When multiple subcharts (dependencies) together provide an optional or swappable feature, those charts should share the same tags. For example, if both nginx and memcached together provide performance optimizations for the main app in the chart, and are required to both be present when that feature is enabled, then they should both have a tags section like this:

    ```yaml
    tags:
      - webaccelerator
    ```

## Labels And Annotations

Please note, [GKE cluster labels](https://cloud.google.com/kubernetes-engine/docs/how-to/creating-managing-labels) and [Kubernetes labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/) are not the same.
GKE cluster labels are arbitrary metadata attached to the cloud resources (GKE cluster, nodes, GCP disks) used to track usage and billing information.
Kubernetes labels are key/value pairs that are attached to Kubernetes objects (e.g. pods).
Kubernetes uses labels internally to associate cluster components and resources (at Kubernetes level, not cloud resources) with one another and manage resource lifecycles.
For this reason, GKE cluster labels (cloud resources) are not propagated to Kubernetes objects (workloads). These best practices only affect Kubernetes labels that are applied through Helm.

1. An item of metadata should be a **label** under the following conditions:
    - It is used by Kubernetes to identify this resource
    - It is useful to expose to operators for the purpose of querying the system.
2. If an item of metadata is not used for querying, it should be set as an **annotation** instead.
3. Helm hooks are always annotations.
4. The following table defines common labels that Helm charts use. Helm itself never requires that a particular label be present. REC are recommended, and should be placed onto a chart for global consistency. OPT are optional More information on the Kubernetes labels, prefixed with `app.kubernetes.io`, is available in the [Kubernetes documentation](https://kubernetes.io/docs/concepts/overview/working-with-objects/common-labels/).
    | Name | Status | Description |
    |------|--------|-------------|
    |`app.kubernetes.io/name` | REC | This should be the app name, reflecting the entire app. Usually `{{ template "name" . }}` is used for this. This is used by many Kubernetes manifests, and is not Helm-specific. |
    | `helm.sh/chart` | REC | This should be the chart name and version: `{{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}`. |
    | `app.kubernetes.io/managed-by` | REC | This should always be set to `{{ .Release.Service }}`. It is for finding all things managed by Helm. |
    | `app.kubernetes.io/instance` | REC | This should be the `{{ .Release.Name }}`. It aids in differentiating between different instances of the same application. |
    | `app.kubernetes.io/version` | OPT | The version of the app and can be set to `{{ .Chart.AppVersion }}`. |
    | `app.kubernetes.io/component` | OPT | This is a common label for marking the different roles that pieces may play in an application. For example, `app.kubernetes.io/component: frontend`. |
    | `app.kubernetes.io/part-of` | OPT | When multiple charts or pieces of software are used together to make one application. For example, application software and a database to produce a website. This can be set to the top level application being supported. |

## Pods and PodTemplates

1. A container image should use a fixed tag or the SHA of the image. It should not use the tags latest, head, canary, or other tags that are designed to be "floating".
    Images may be defined in the values.yaml file to make it easy to swap out images.

    ```yaml
    image: {{ .Values.redisImage | quote }}
    ```

    An image and a tag may be defined in values.yaml as two separate fields:

    ```yaml
    image: "{{ .Values.redisImage }}:{{ .Values.redisTag }}"
    ```

2. Set the `imagePullPolicy` to `IfNotPresent` by default.
3. All `PodTemplate` sections should specify a selector.
4. Include Health Checks ([probes](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/), Liveness, Readiness and/or Startup Probes) wherever practical.
5. Allow configurable resource requests and limits.
6. Allow customization of the application configuration.
7. Always define named ports in the podSpec. Whenever possible name the ports with the [IANA defined service name](https://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.xhtml).

## Custom Resource Definitions

When working with Custom Resource Definitions (CRDs), it is important to distinguish two different pieces:

- There is a declaration of a CRD. This is the YAML file that has the kind `CustomResourceDefinition`.
- Then there are resources that use the CRD. Say a CRD defines `foo.example.com/v1`. Any resource that has `apiVersion: example.com/v1` and `kind Foo` is a resource that uses the CRD.

1. The declaration must be registered before any resources of that CRDs kind(s) can be used. And the registration process sometimes takes a few seconds. There are 2 methods:

    1. Method 1: Let helm Do It For You: Put CRDs in a special directory called `crds`. These CRDs are **not templated**, but will be installed by default when running a `helm install` for the chart. If the CRD already exists, it will be skipped with a warning. If you wish to skip the CRD installation step, you can pass the `--skip-crds flag`.
        Caveats:
          - There is no support for upgrading or deleting CRDs using Helm.
          - The `--dry-run` flag of `helm install` and `helm upgrade` is not currently supported for CRD.
    2. Method 2: Separate Charts: Put the CRD definition in one chart, and then put any resources that use that CRD in another chart. **In this method, each chart must be installed separately.**

## Role-Based Access Control

1. RBAC and ServiceAccount configuration should happen under separate keys as they are separate things.

    ```yaml
    rbac:
      # Specifies whether RBAC resources should be created
      create: true

    serviceAccount:
      # Specifies whether a ServiceAccount should be created
      create: true
      # The name of the ServiceAccount to use.
      # If not set and create is true, a name is generated using the fullname template
      name:
    ```

2. RBAC Resources Should be Created by Default. That is, `rbac.create` should be a boolean value controlling whether RBAC resources are created. The default should be `true`.
3. `serviceAccount.name` should be set to the name of the `ServiceAccount` to be used by access-controlled resources created by the chart. If `serviceAccount.create` is `true`, then a `ServiceAccount` with this name should be created. If the name is not set, then a name is generated using the `fullname` template, If `serviceAccount.create` is `false`, then it should not be created, but it should still be associated with the same resources so that manually-created RBAC resources created later that reference it will function correctly. If `serviceAccount`.create is `false` and the name is not specified, then the default `ServiceAccount` is used.
    The following helper template should be used for the ServiceAccount.

    ```go
    {{/*
    Create the name of the service account to use
    */}}
    {{- define "mychart.serviceAccountName" -}}
    {{- if .Values.serviceAccount.create -}}
        {{ default (include "mychart.fullname" .) .Values.serviceAccount.name }}
    {{- else -}}
        {{ default "default" .Values.serviceAccount.name }}
    {{- end -}}
    {{- end -}}
    ```

## Documentation

1. Every defined property in values.yaml should be documented. The documentation string should begin with the name of the property that it describes, and then give at least a one-sentence description. (Repeated from [Values](#values).)
   1. **TODO:** Evaluate [`helm-docs`](https://github.com/norwoodj/helm-docs) and its automation.
2. Include an in-depth `README.md`, with:
    - Short description of the Chart.
    - Any prerequisites or requirements.
    - Descriptions of options in values.yaml and default values.
    - Any other information that may be relevant to the installation or configuration of the chart.
3. Include a short NOTES.txt, with:
    - Any relevant post-installation information for the Chart.
    - Instructions on how to access the application or service provided by the Chart.

## Technical

1. Charts must pass the linter ([GitHub Action check](../.github/workflows/helm_lint.yml)).
2. Must successfully launch with default values (`helm install`).
    - All pods go to the running state.
    - All services have at least one endpoint.

## References

- [helm.sh Chart Best Practices Guide](https://helm.sh/docs/chart_best_practices/)
- [Kubernetes Recommended Labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/common-labels/)
- [Honestbee - Helm Chart Conventions](https://gist.github.com/so0k/f927a4b60003cedd101a0911757c605a)
