# Kubernetes: Certified Application Developer (CKAD)

- [Kubernetes Cheatsheet](https://kubernetes.io/docs/reference/kubectl/quick-reference/)
- [Kubernetes Overview](https://kubernetes.io/docs/reference/kubectl/)

## Promo Code for Exam

Keep the code - `20KLOUD` handy while registering for the CKA or CKAD exams at Linux Foundation to get a 20% discount.

## `kubectl` with formatted output

- The default output format for all `kubectl` commands is the human-readable plain-text format.
- The `-o` flag allow us to output the details in several different formats

```sh
kubectl [command][TYPE][NAME] -o <output_format>
```

- `-o json`: Output a JSON formatted API object
- `-o name` Print only the resource name and nothing else
- `-o wide`: Output in the plain-text format with any additional information
- `-o yaml`: Output a YAML formatted API object
